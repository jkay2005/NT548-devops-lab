output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_node_instance_id" {
  value = aws_instance.private_node.id
}

output "private_node_private_ip" {
  value = aws_instance.private_node.private_ip
}
