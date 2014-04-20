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
module MCollective
  module Agent
    class Apt<RPC::Agent
      activate_when do
        File.executable?("/usr/bin/apt-get")
      end

      action "upgrades" do
        out = ""
        reply[:status] = run("/usr/bin/apt-get dist-upgrade -y -s",
                             :stdout => out, :chomp => true)

        out.split(/\n/).each do |line|
          matches = /^(\d+) upgraded, (\d+) newly installed, (\d+) to remove and (\d+) not upgraded\.$/.match(line)

          if matches
            reply[:upgrades] = matches[1].to_i
            reply[:installs] = matches[2].to_i
            reply[:removes] = matches[3].to_i
            reply[:keeps] = matches[4].to_i
          end
        end
      end

      action "installed" do
        out = ""
        reply[:status] = run("/usr/bin/dpkg -l | grep '^ii' | wc -l",
                             :stdout => out, :chomp => true)
        reply[:installed] = out.to_i
      end

      action "clean" do
        reply[:status] = run("/usr/bin/apt-get clean")
      end

      action "update" do
        reply[:status] = run("/usr/bin/apt-get update")
      end

      action "upgrade" do
        reply[:status] = run("/usr/bin/apt-get upgrade -o DPkg::options::='--force-confdef' -o Dpkg::Options::='--force-confold' -y",
                             :environment => { 'APT_LISTCHANGES_FRONTEND' => 'mail', 'DEBIAN_FRONTEND' => 'noninteractive' })
      end

      action "distupgrade" do
        reply[:status] = run("/usr/bin/apt-get dist-upgrade -o DPkg::options::='--force-confdef' -o Dpkg::Options::='--force-confold' -y",
                             :environment => { 'APT_LISTCHANGES_FRONTEND' => 'mail', 'DEBIAN_FRONTEND' => 'noninteractive' })
      end

      action "configure_pending" do
        reply[:status] = run("/usr/bin/dpkg --configure --pending",
                             :environment => { 'DEBIAN_FRONTEND' => 'noninteractive' })
      end
    end
  end
end
