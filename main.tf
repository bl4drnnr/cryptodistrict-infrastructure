module "cryptonodes_infrastructure" {
    source     = "./modules/droplets"
    
    do_token   = var.do_token
}
