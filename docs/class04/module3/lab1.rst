Lab 3.1: BIG-IQ Configuration Management (CM)
---------------------------------------------


1. Reset both BIG-IQ CM and DCD Execute the bash script

    ::

        # cd /home/f5/f5-bigiq-onboarding
        # ./cmd_bigiq_onboard_reset.sh pause

    The script will do in this order:

    1. Delete existing applications
    2. Execute the ``clear-rest-storage -d`` command on both BIG-IQ CM and DCD
    3. Uninstall existing ansible-galaxy roles (if any)

2. 