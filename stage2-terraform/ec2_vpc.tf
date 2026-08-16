# 1. Tự động truy vấn bản Ubuntu 22.04 LTS mới nhất
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 2. Tạo IAM Role chuẩn SSM cho EC2 (Vá CKV2_AWS_41)
resource "aws_iam_role" "ec2_ssm_role" {
  name = "devsecops-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

#  Attachment quyền SSM
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#  Attachment quyền ECR Read-Only (ISC2 Least Privilege)
resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

#  Instance Profile cho EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "devsecops-ec2-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}
# 3. Security Group (Suppress lỗi cố ý mở Web Port 80)
resource "aws_security_group" "web_sg" {
  name        = "devsecops-web-sg"
  description = "Allow HTTP inbound traffic"

  #checkov:skip=CKV_AWS_260: "Mo Port 80 cho Web POC"
  ingress {
    description = "Allow Web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #checkov:skip=CKV_AWS_382: "Cho phép Outbound cap nhat package"
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH only from my home IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["27.74.9.110/32"] # Chỉ cho phép đúng IP của anh
  }


  tags = { Name = "devsecops-web-sg" }
}



# 4. Máy chủ EC2 đã gia cố (Vá CKV_AWS_79, CKV_AWS_126, CKV_AWS_135)
# Đẩy Public Key vừa tạo lên AWS
resource "aws_key_pair" "deployer" {
  key_name   = "devsecops-ec2-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "web_server" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name # <--- THÊM ĐÚNG DÒNG NÀY NÈ ANH!
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  ebs_optimized = true
  monitoring    = true

  # Ép dùng IMDSv2 chống SSRF attack
  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    instance_metadata_tags      = "enabled"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  tags = {
    Name        = "devsecops-fastapi-ec2"
    Environment = "DevSecOps"
  }
}
