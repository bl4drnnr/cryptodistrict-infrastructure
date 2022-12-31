module "openvpn_do_infrastructure_module" {
    source     = "./modules/droplets"
    
    do_token   = var.do_token
}
