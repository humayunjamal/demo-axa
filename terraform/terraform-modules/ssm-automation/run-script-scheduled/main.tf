resource "aws_ssm_document" "this" {
  name          = "${var.document_name}"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "${var.description}",
    "parameters": {

    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["${var.runCommand}"]
          }
        ]
      }
    }
  }
DOC

  tags = "${var.tags}"
}

resource "aws_ssm_association" "this" {
  name                = "${aws_ssm_document.this.name}"
  association_name    = "${var.association_name}"
  schedule_expression = "${var.schedule_expression}"

  targets {
    key    = "${var.targets_key}"
    values = ["${var.targets_values}"]
  }
}
