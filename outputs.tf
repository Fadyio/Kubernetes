output "control_plane_public_ip" {
  value = aws_instance.control_plane.public_ip
}

output "worker_nodes_public_ip" {
  value = aws_instance.worker_nodes.public_ip
}