output "address" {
  value = "Instances: ${element(aws_instance.ethereum.*.id, 0)}"
}
