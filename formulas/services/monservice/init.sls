/srv/stuff/substuf:
  file.directory:
    - user: deploy
    - group: users
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode