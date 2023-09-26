variable "logicapps_tags" {
  type = map(string)
  default = {
    BILLINGCODE: "",
    CONTACTS: "{\"Group\":\"ENTERINFORMATION\",\"PrimaryContact\":\"ENTERINFORMATION\",\"SecondaryContact\":\"ENTERINFORMATION\",\"BusinessOwner\":\"ENTERINFORMATION\"} ",
    COUNTRY: "NZ",
    CS: "{\"Classification\":ENTERINFORMATION\",}",
    ENVIRONMENT: "DEV",
    FUNCTION: "",
    displayName: "LogicApp"
  }
}

// ip ranges allowed access to app service
variable "ip_restriction_object" {
  type = list(object({ip = string, name = string, priority = string}))
  default = [
    {
      ip = "0.0.0.0/16"
      name = "ENTRY-NAME"
      priority = "1"
    },
    {
      ip = "0.0.0.0/16"
      name = "ENTRY-NAME"
      priority = "1"
    },
    {
      ip = "0.0.0.0/16"
      name = "ENTRY-NAME"
      priority = "1"
    }
  ]
}

variable "AppService-RG" {
  default = "APP-SERVICE-RG-NAME"
}

variable "AppService-Plan" {
  default = "APP-SERVICE-PLAN-NAME"
}

//I think the app service name needs to be lowercase for the cert to work
variable "AppService-Name" {
  default = "APP-SERVICE-NAME"
}

variable "appservice-sub" {
  default = "APP-SERVICE-SUBSCRIPTION-ID"
}

variable "dns-sub" {
  default = "DNS-SUBSCRIPTION-ID"
}

variable "dns-rg" {
  default = "DNS-RD-NAME"
}

variable "dns-name" {
  default = "DNS-ADDRESS-NAME" //eg const.com ; const.co.uk
}

variable "environment" {
  default = "Development"
}

variable "custom-dns-name"{
  default = "CUSTOM-URL-NAME" // custom = custom.const.com
}