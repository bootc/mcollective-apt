# encoding: utf-8
# Copyright (C) 2011  Mark Stanislav <mark.stanislav@gmail.com>
#               2012  three18ti
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
class MCollective::Application::Apt<MCollective::Application
  description "Manage the APT package manager"

  usage <<-END_OF_USAGE
mco apt [OPTIONS] [FILTERS] <ACTION> [CONCURRENCY|MESSAGE]
Usage: mco apt <upgrades|installed|clean|update|upgrade|distupgrade|configure_pending>

The ACTION can be one of the following:

    upgrades    - report the number of available updates and packages that will
                  be installed or removed as a result, plus packages kept back
    installed   - report the total number of installed packages
    clean       - clears out the local repository of retrieved package files
    update      - resynchronize the package index files from their sources
    upgrade     - perform an apt-get upgrade
    distupgrade - perform an apt-get dist-upgrade
    configure_pending - configure all pending packages
END_OF_USAGE

  def post_option_parser(configuration)
    if ARGV.length >= 1
      configuration[:command] = ARGV.shift

      unless ["upgrades", "installed", "clean", "update", "upgrade", "distupgrade", "configure_pending"].include?(configuration[:command])
        raise_message(1)
      end
    else
      raise_message(2)
    end
  end

  def raise_message(message, *args)
    messages = {1 => "Action must be upgrades, installed, clean, update, upgrade, distupgrade or configure_pending",
                2 => "Please specify a command.",
                6 => "Do not know how to handle the '%s' command"}

    raise messages[message] % args
  end

  def client
    @client ||= rpcclient("apt")
  end

  def calculate_longest_hostname(results)
    results.map{|s| s[:sender]}.map{|s| s.length}.max
  end

  def display_results_lambda(results, lam)
    return false if results.empty?

    sender_width = calculate_longest_hostname(results) + 1
    pattern = "   %%-%ds  %%s" % sender_width

    Array(results).sort_by { |hsh| hsh[:sender] }.each do |result|
      if result[:statuscode] == 0
        line = if result[:data][:status] == 0 then
                 lam.call(result)
               else
                 MCollective::Util.colorize(:red, "Exit code %d" % [ result[:data][:status] ])
               end
        puts pattern % [result[:sender] + ":", line]
      else
        puts pattern % [result[:sender] + ":", MCollective::Util.colorize(:red, result[:statusmsg])]
      end
    end
  end

  def display_results_single_field(results, field)
  end

  def display_results_status(results)
    display_results_lambda(results, lambda {|result|
      "OK"
    })
  end

  def upgrades_command
    display_results_lambda(client.upgrades, lambda {|result|
      upg = result[:data][:upgrades]
      inst = result[:data][:installs]
      rem = result[:data][:removes]
      keep = result[:data][:keeps]

      str = nil
      colour = nil

      if upg == 0 and inst == 0 and rem == 0
        str = "No pending upgrades"
      elsif inst == 0 and rem == 0
        str = "%d upgrades" % [ upg ]
        colour = :green
      elsif rem == 0
        str = "%d upgrades, %d installs" % [ upg, inst ]
        colour = :yellow
      else
        str = "%d upgrades, %d installs, %d removes" % [ upg, inst, rem ]
        colour = :red
      end

      if keep != 0
        str << " (%d kept back)" % [ keep ]
      end

      if colour
        MCollective::Util.colorize(colour, str)
      else
        str
      end
    })
    printrpcstats :summarize => true
    halt client.stats
  end

  def installed_command
    display_results_lambda(client.installed, lambda {|result|
      result[:data][:installed]
    })
    printrpcstats :summarize => true
    halt client.stats
  end

  def clean_command
    display_results_status(client.clean)
    printrpcstats :summarize => true
    halt client.stats
  end

  def update_command
    display_results_status(client.update)
    printrpcstats :summarize => true
    halt client.stats
  end

  def upgrade_command
    display_results_status(client.upgrade)
    printrpcstats :summarize => true
    halt client.stats
  end

  def distupgrade_command
    display_results_status(client.distupgrade)
    printrpcstats :summarize => true
    halt client.stats
  end

  def configure_pending_command
    display_results_status(client.configure_pending)
    printrpcstats :summarize => true
    halt client.stats
  end

  def main
    impl_method = "%s_command" % configuration[:command]

    if respond_to?(impl_method)
      send(impl_method)
    else
      raise_message(6, configuration[:command])
    end
  end
end
