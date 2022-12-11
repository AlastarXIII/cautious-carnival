import scapy.layers.l2 as scapy
import argparse


def get_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--target", dest="ip", help="Specify the IP range to scan")
    options = parser.parse_args()
    if not options.ip:
        parser.error("Please specify an IP range, use --help for more info.")
    return options


def print_result(results_list):
    if not results_list:
        print("Scanning failed. Check the specified IP range")
        exit(1)
    print("IP\t\t\tMAC Address\n----------------------------------------------------------------")
    for result in results_list:
        print(result["ip"] + "\t\t" + result["mac"])


def scan(ip):
    arp_request = scapy.ARP(pdst=ip)
    broadcast = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")
    broadcast_requests = broadcast/arp_request
    answered_list = scapy.srp(broadcast_requests, timeout=1, verbose=False)[0]
    results_list = []
    for answer in answered_list:
        results_list.append({"ip": answer[1].psrc, "mac": answer[1].hwsrc})
    return results_list


options = get_arguments()
scan_result = scan(options.ip)
print_result(scan_result)
