#
# Cookbook Name:: chef-nginx
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

nginx_prefix = node[:passenger][:nginx_prefix]

packages = case node[:platform]
           when "ubuntu","debian"
             [
               "build-essential",
               "libcurl4-openssl-dev",
               "libssl-dev",
               "zlib1g-dev"
             ].compact

           end
unless packages.nil?
  packages.each do |pkg|
    package pkg do
      action :install
    end
  end
end

gem_package "passenger" do
  action :install
end

execute "passenger_module" do
  command "passenger-install-nginx-module --auto-download --auto --prefix=#{node[:passenger][:nginx_prefix]}"
  action :run
  not_if do
    File.exists?("/opt/nginx")
  end
end
