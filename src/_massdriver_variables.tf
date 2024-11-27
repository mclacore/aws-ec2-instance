// Auto-generated variable declarations from massdriver.yaml
variable "md_metadata" {
  type = object({
    default_tags = object({
      managed-by  = string
      md-manifest = string
      md-package  = string
      md-project  = string
      md-target   = string
    })
    deployment = object({
      id = string
    })
    name_prefix = string
    observability = object({
      alarm_webhook_url = string
    })
    package = object({
      created_at             = string
      deployment_enqueued_at = string
      previous_status        = string
      updated_at             = string
    })
    target = object({
      contact_email = string
    })
  })
}
variable "vpc" {
  type = object({
    data = object({
      infrastructure = object({
        arn  = string
        cidr = string
        internal_subnets = list(object({
          arn = string
        }))
        private_subnets = list(object({
          arn = string
        }))
        public_subnets = list(object({
          arn = string
        }))
      })
    })
    specs = optional(object({
      aws = optional(object({
        region = optional(string)
      }))
    }))
  })
}
// Auto-generated variable declarations from massdriver.yaml
variable "ami" {
  type = string
}
variable "enable_ssh" {
  type = bool
}
variable "instance_type" {
  type = string
}
variable "user_data" {
  type    = string
  default = null
}
// Auto-generated variable declarations from massdriver.yaml
variable "aws_authentication" {
  type = object({
    data = object({
      arn         = string
      external_id = optional(string)
    })
    specs = object({
      aws = optional(object({
        region = optional(string)
      }))
    })
  })
}
// Auto-generated variable declarations from massdriver.yaml
variable "cdn" {
  type = object({
    data = object({
      infrastructure = object({
        ari = string
        endpoints = list(object({
          hostname = optional(string)
          name     = optional(string)
        }))
      })
      security = object({
        iam = optional(any)
      })
    })
    specs = object({
      azure = optional(object({
        region = string
      }))
    })
  })
}
