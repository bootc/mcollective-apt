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

