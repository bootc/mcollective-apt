# Copyright (C) 2011  Mark Stanislav <mark.stanislav@gmail.com>
#               2012  three18ti
#               2012  Rémi "binbashfr"
#               2014  Chris Boot <bootc@bootc.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
metadata :name => "apt",
         :description => "Debian APT service",
         :author => "Chris Boot, based on work by Mark Stanislav",
         :license => "GPLv2",
         :version => "1.4",
         :url => "https://github.com/bootc/mcollective-apt",
         :timeout => 600

requires :mcollective => "2.2.1"

action "upgrades", :description => "Get the total number of packages available for upgrade" do
    display :always

    output :upgrades,
           :description => "Total number of packages that would be upgraded",
           :display_as  => "Upgrades"
    output :installs,
           :description => "Total number of packages that would be installed",
           :display_as  => "Installs"
    output :removes,
           :description => "Total number of packages that would be removed",
           :display_as  => "Removes"
    output :keeps,
           :description => "Total number of packages not upgraded",
           :display_as  => "Keeps"
    output :status,
           :description => "Command execution status",
           :display_as  => "Status"
end

action "installed", :description => "Get the total number of packages installed" do
    display :always

    output :installed,
           :description => "Total number of packages installed",
           :display_as  => "Packages Installed"
    output :status,
           :description => "Command execution status",
           :display_as  => "Status"
end

action "clean", :description => "Remove all package archive files" do
    display :always

    output :status,
           :description => "Command execution status",
           :display_as  => "Status"
end

action "update", :description => "Update repository information" do
    display :always

    output :status,
           :description => "Command execution status",
           :display_as  => "Status"
end

action "upgrade", :description => "Perform System Upgrade" do
    display :always

    output :status,
           :description => "Command execution status",
           :display_as  => "Status"
end

action "distupgrade", :description => "Perform System Dist-Upgrade" do
    display :always

    output :status,
           :description => "Command execution status",
           :display_as  => "Status"
end

action "configure_pending", :description => "Configure all pending packages" do
    display :always

    output :status,
           :description => "Command execution status",
           :display_as  => "Status"
end

