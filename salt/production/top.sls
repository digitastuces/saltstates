production:
    '*':
        - common
    # Prod minions
    'prod.*':
        - common
development:
    '*':
        - common