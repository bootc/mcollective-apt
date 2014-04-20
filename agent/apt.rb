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
