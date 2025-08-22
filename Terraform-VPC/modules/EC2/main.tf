resource "aws_instance" "web" {
  count                       = length(var.EC2_names)
  ami                         = data.aws_ami.amazon-2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id]
  subnet_id                   = var.subnets[count.index]
  availability_zone           = data.aws_availability_zones.available.names[count.index]
  user_data_replace_on_change = true
  metadata_options {
    http_tokens   = "required" # Enforces IMDSv2
    http_endpoint = "enabled"  # Ensures metadata service is available
  }

  user_data = <<EOF
  
#!/bin/bash
# Update & install Apache
sudo yum update -y
sudo yum install -y httpd

# Start & enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Create Thalaivar Quotes Page
cat <<EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Thalaivar Quotes</title>
  <style>
    body {
      background-color: black;
      color: gold;
      font-family: "Trebuchet MS", sans-serif;
      text-align: center;
      margin: 0;
      padding: 0;
    }
    header {
      background: linear-gradient(to right, red, orange, gold);
      padding: 20px;
      font-size: 40px;
      font-weight: bold;
      text-shadow: 2px 2px 5px black;
    }
    .quote {
      font-size: 28px;
      margin: 30px auto;
      padding: 15px;
      width: 70%;
      border: 2px solid gold;
      border-radius: 15px;
      background: rgba(255, 215, 0, 0.1);
      box-shadow: 0px 0px 15px red;
    }
    .footer {
      margin-top: 40px;
      font-size: 20px;
      color: #ffcc00;
    }
  </style>
</head>
<body>
  <header>🌟 Superstar Rajinikanth Quotes 🌟</header>

  <div class="quote">"Naan oru thadava sonna, nooru thadava sonna maari." 🔥</div>
  <div class="quote">"En vazhi, thani vazhi." 🚶</div>
  <div class="quote">"Idhu eppadi irukku?" 😎</div>
  <div class="quote">"Kashtapadaama edhuvum kidaikadhu da." 💪</div>
  <div class="quote">"Vetri nichayam, aana adhu late-a varum." 🕰️</div>
  <div class="quote">"Nallavana irukkanum... aana romba nallavana irukka koodathu." ⚖️</div>
  <div class="quote">"Style ah oru thadava sonna podhum, repeat panna vendam!" ✨</div>

  <div class="footer">🔥 #ThalaivarForever | #Superstar | #NeruppuDa 🔥</div>
</body>
</html>
EOF




  tags = {
    Name = var.EC2_names[count.index]
  }
}
