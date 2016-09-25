#cloud-config

ssh_pwauth: true

groups:
  - osic-lab

users:
  - name: cicd
    passwd: $6$rounds=4096$DWIvD0b83l1wOVo$3Ww47Krh0JkgohulOJbr4W7WcvQuzlapHd0/qfjEmGvrA1YHjxmhS.Up6B/WV1/b5Yc5J7kvvPFvIbcqpMHII/
    lock_passwd: False
  - name: osicer-admin
    passwd: $6$rounds=4096$1kKKKeNOhu0V7L4$qeDpEqAkhvhvthfdPwAPTVjMVtYT7HSlUYGDhdgkl/GlkSDi9qrZ8VLb/S6hgCe7F48wThpDmgHskYLaaPBrQ.
    lock_passwd: False
    sudo:
        - ALL=(ALL) ALL
