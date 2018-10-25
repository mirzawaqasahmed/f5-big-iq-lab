Lab 3.1: BIG-IQ Configuration Management (CM)
---------------------------------------------

.. warning:: This lab has steps to reset the BIG-IQ CM and DCD to its factory configuration. Plan accordinly if you need to run other classes/labs (this one should be the last one).

1. Reset both BIG-IQ CM and DCD Execute the bash script

    ::

        # cd /home/f5/f5-bigiq-onboarding
        # ./cmd_bigiq_onboard_reset.sh pause

    The script will do in this order:

    1. Delete existing applications
    2. Execute the ``clear-rest-storage -d`` command on both BIG-IQ CM and DCD
    3. Uninstall existing ansible-galaxy roles (if any)

2. 