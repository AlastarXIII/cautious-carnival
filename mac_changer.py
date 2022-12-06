import subprocess
import optparse
import re


def print_intro():
    print('''    #       #
  ##         ##
###           ###
 ####       ####
   ########### 
 ##           ##
 ##  0     0  ##
 ##           ##
 ##  —|—|—|—  ##
   ###########''')
    print("Welcome to ALASTAR MAC changer tool!")


def get_arguments():
    parser = optparse.OptionParser()
    parser.add_option("-i", "--interface", dest="interface", help="Specify the interface to change its MAC address")
    parser.add_option("-m", "--mac", dest="mac_address", help="Specify the new MAC address")
    (options, arguments) = parser.parse_args()
    if not options.interface:
        parser.error("[-] Please specify an interface, use --help for more info.")
    elif not options.new_mac:
        parser.error("[-] Please specify a MAC address, use --help for more info.")
    return options


def change_mac(interface, new_mac):
    subprocess.call(["ifconfig", interface, "down"])
    subprocess.call(["ifconfig", interface, "hw", "ether", new_mac])
    subprocess.call(["ifconfig", interface, "up"])


def check_mac_format(new_mac):
    mac_check_result = re.search(r"\w\w:\w\w:\w\w:\w\w:\w\w:\w\w", str(new_mac))
    if not mac_check_result:
        print("[-] The MAC address has a bad format. Please input a correct MAC address")
        exit(1)


def get_mac_address(interface):
    ifconfig_result = subprocess.check_output("ifconfig", interface)
    mac_search_result = re.search(r"\w\w:\w\w:\w\w:\w\w:\w\w:\w\w", str(ifconfig_result))
    if mac_search_result:
        return mac_search_result.group(0)
    else:
        print("[-] Couldn't find a MAC address for the specified interface")
        exit(1)


print_intro()
options = get_arguments()
get_mac_address(options.interface)
change_mac(options.interface, options.new_mac)
current_mac_address = get_mac_address(options.interface)
if current_mac_address == options.new_mac:
    print("[+] MAC address is changed to " + options.new_mac + " for interface " + options.interface)
else:
    print("[-] MAC address did not get changed")
