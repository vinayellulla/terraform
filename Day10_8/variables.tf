variable "bucket_names" {
  type    = list(string)
  default = ["hello-vinay-ellulla", "hello-DP-ellulla", "hello-opinio-ellulla"]
}

variable "bucket_names_set" {
  type    = set(string)
  default = ["hello-vinay-ellulla-1", "hello-DP-ellulla-2", "hello-opinio-ellulla-3"]
}

# list(string) = ["Hello", Hello2] list[0] list[1]
# set(string)  = ["Hello", Hello2] for_each
# map(string)  = {name : "ellulla" , name2 : "vinay"}

