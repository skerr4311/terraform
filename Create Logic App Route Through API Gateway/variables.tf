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

variable "environment" {
  default = "DEV"
}

variable "logicapp_rg" {
  default = "LOGIC-APP-RG-NAME"
}

variable "apim_rg" {
  default = "API-MANAGEMENT-RG-NAME"
}

variable "apim_name" {
  default = "API-MANAGEMENT-NAME"
}

variable "audience" {
  default = "CLIENT-ID-THAT-IS-ALLOWED-ACCESS"
}

variable "logicapp" {
  default = "LOGIC-APP-NAME"
}

variable "endpoint" {
  default = "ENDPOINT-FOR-NEW-LOGIC-APP"
}