#!/bin/bash

# Storyline: Menu for admin, VPN, and Security functions

function invalid_opt() {

        echo ""
        echo "Invalid option!"
        echo ""
        sleep 2

}

function menu() {

        # clears screen
        clear
        echo "[1] Admin Menu"
        echo "[2] Security Menu"
        echo "[3] Exit"
        read -p "Please enter a choice above: " choice

        case "$choice" in

                1) admin_menu
                ;;

                2) security_menu
                ;;

                3) exit 0

                ;;
                *)

                        invalid_opt
                        # Call the main menu
                        menu
                ;;
        esac



}

function admin_menu() {

        clear
        echo "[L]ist Running Processes"
        echo "[N]etwork Sockets"
        echo "[V]PN Menu "
        echo "[4] Exit"
        read -p "Please enter a choice above: " choice

        case "$choice" in

                L|l) ps -ef |less
                ;;
                N|n) netstat -an --inet |less
                ;;
                V|v) vpn_menu
                ;;
                4) exit 0
                ;;

                *)
                        invalid_opt
                ;;

        esac

admin_menu
}

function vpn_menu() {

        clear
        echo "[A]dd a peer"
        echo "[D]elete a peer"
        echo "[C]heck to see if a user exists"
        echo "[B]ack to admin menu"
        echo "[M]ain menu"
        echo "[E]xit"
        read -p "Please select an option: " choice

        case "$choice" in

                A|a)
                # Add a peer
                bash peer.bash
                # tells us whether or not user was created
                tail -6 wg0.conf |less

                ;;
                D|d)

                        # Create a prompt for the user to delete
                        echo "Please enter a user that you want to delete: "
                        read t_user

                        # Call the manage-users.bash and pass the proper switches and argument
                        # to delete the user.
                        echo ${t_user}
                        bash manage_users.bash -d -u "${t_user}"

                ;;
                C|c)
                # Creates prompt to ask what user you are looking for
                echo "What user are you looking for?"
                read t_user

                if grep "${t_user}" wg0.conf
                then

                # if user is found
                echo "This user exists"
                else

                # if user isn't found
                echo "This user doesn't exist"
                fi
                # timer to show the results
                sleep 2

                ;;
                B|b) admin_menu
                ;;
                M|m) menu
                ;;
                E|e) exit 0
                ;;
                *)
                        invalid_opt

                ;;

        esac

vpn_menu
}

function security_menu() {

        clear
        echo "[L]ist open network sockets"
        echo "[C]heck if any user beside root has UID of 0"
        echo "[H]istory of the last 10 logged in users"
        echo "[S]ee currently logged in users"
        echo "[M]ain menu"
        echo "[B]locklist menu"
        echo "[E]xit"
        read -p "Please select an option: " choice
        case "$choice" in


                L|l)
                ss -s|less
                ;;

                C|c)
                grep 'x:0:' /etc/passwd | less
                ;;

                H|h)
                last -10|less
                ;;

                S|s)
                who |less
                ;;

                M|m) menu
                ;;

                B|b) blocklist_menu
                ;;

                E|e) exit 0
                ;;

                *)
                        invalid_opt
                        # Call the menu
                        menu
                ;;

        esac

security_menu
}



function blocklist_menu() {

        clear
        echo "[L]inux blocklist generator"
        echo "[M]ac blocklist generator"
        echo "[W]indows blocklist generator"
        echo "[U]rl blocklist generator"
        echo "[C]isco blocklist generator"
        echo "[E]xit"
        read -p "Please select an option: " choice
        case "$choice" in


                L|l)
                bash threat-menu.bash -L
                ;;

                M|m)
                bash threat-menu.bash -M
                ;;

                W|w)
                bash threat-menu.bash -W
                ;;

                U|u)
                bash threat-menu.bash -U
                ;;
                C|c)
                bash threat-menu.bash -C
                ;;

                E|e) exit 0
                ;;

                *)
                        invalid_opt
                        


                ;;

        esac

blocklist_menu
}



# Call the main function
menu
