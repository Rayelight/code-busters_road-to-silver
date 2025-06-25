variable "tables" {
    type = map(object({
        columns = list(object({
            name = string
            type = string
        }))
        partitions = list(object({
            name = string
            type = string
        }))
    }))
}

variable "data_bucket" {
    type = string
}
