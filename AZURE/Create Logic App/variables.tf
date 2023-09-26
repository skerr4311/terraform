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
  default = "RESOURCEGROUPNAME"
}

variable "logicapp" {
  default = "LOGICAPPNAME"
}