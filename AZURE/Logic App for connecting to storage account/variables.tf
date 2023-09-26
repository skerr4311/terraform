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

variable "primaryLocation" {
  default = "westus2"
}

variable "environment" {
  default = "DEV"
}

variable "logicapp_rg" {
  default = "LOGIC-APP-RG-NAME"
}

variable "storage" {
  default = "STORAGE-ACCOUNT-NAME"
}

variable "storage_rg" {
  default = "STORAGE-RG-NAME"
}

//LOGIC APP NAMES:
variable "filestorage" {
  default = "LOGIC-APP-NAME"
}
