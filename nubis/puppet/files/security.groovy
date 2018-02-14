#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule

def instance = Jenkins.getInstance()

println "--> set authorization strategy"
def strategy = new GlobalMatrixAuthorizationStrategy()

strategy.add(Jenkins.ADMINISTER, "admin")
strategy.add(Jenkins.ADMINISTER, "authenticated")
strategy.add(Jenkins.READ, "anonymous")

instance.setAuthorizationStrategy(strategy)

println "--> creating proxy configuration"
def proxy = new hudson.ProxyConfiguration('proxy.service.consul', 3128, '', '', '127.0.0.1,169.254.169.254')
instance.proxy = proxy

println "--> Enable Slave to Master Access Control" 
instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)

instance.save()
