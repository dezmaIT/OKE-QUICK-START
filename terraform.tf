terraform {
  backend "http" {
    address = ${{ vars.TERRAFORM_STATE_FILE }}
    update_method = "PUT"
  }
}