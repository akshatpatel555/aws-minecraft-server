output "instance_public_ip" {
  description = "Public IP address of the Minecraft server"
  value       = aws_instance.minecraft.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.minecraft.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/myKeyPair.pem ubuntu@${aws_instance.minecraft.public_ip}"
}