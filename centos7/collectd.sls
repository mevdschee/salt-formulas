{% set collectd_ip = salt['pillar.get']('collectd:collectd_ip', "salt") %}

{% set interface = salt['cmd.shell']("ip -4 route get 8.8.8.8 | awk {'print $5'} | tr -d '\n'") %}

collectd:
  pkg.installed

/etc/collectd.d/remote.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        LoadPlugin network
        <Plugin "network">
          Server "{{ collectd_ip }}"
        </Plugin>

/etc/collectd.d/disk.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        LoadPlugin disk
        <Plugin disk>
          Disk "/^[vhs]d[a-f]$/"
          IgnoreSelected false
          #UseBSDName false
          #UdevNameAttr "DEVNAME"
        </Plugin>

/etc/collectd.d/cpu.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        <Plugin cpu>
          ReportByCpu true
          ReportByState true
          ValuesPercentage true
        </Plugin>

/etc/collectd.d/df.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        LoadPlugin df
        <Plugin df>
          FSType sysfs
          FSType proc
          FSType devtmpfs
          FSType devpts
          FSType tmpfs
          FSType fusectl
          FSType cgroup
          FSType overlay
          FSType debugfs
          FSType pstore
          FSType securityfs
          FSType hugetlbfs
          FSType squashfs
          FSType mqueue
          IgnoreSelected true
          ReportByDevice false
          ReportReserved true
          ValuesAbsolute true
          ValuesPercentage true
          ReportInodes true
        </Plugin>

/etc/collectd.d/swap.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: LoadPlugin swap

/etc/collectd.d/uptime.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: LoadPlugin uptime

/etc/collectd.d/processes.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: LoadPlugin processes

/etc/collectd.d/tcpconns.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        LoadPlugin tcpconns
        <Plugin "tcpconns">
          AllPortsSummary true
        </Plugin>

/etc/collectd.d/contextswitch.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: LoadPlugin contextswitch

/etc/collectd.d/irq.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: LoadPlugin irq

/etc/collectd.d/interface.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        <Plugin "interface">
          Interface "{{ interface }}"
          IgnoreSelected false
        </Plugin>

enable-collectd-service:
  service.running:
    - name: collectd
    - enable: True
    - watch:
      - file: /etc/collectd.d/remote.conf
      - file: /etc/collectd.d/disk.conf
      - file: /etc/collectd.d/cpu.conf
      - file: /etc/collectd.d/df.conf
      - file: /etc/collectd.d/swap.conf
      - file: /etc/collectd.d/uptime.conf
      - file: /etc/collectd.d/processes.conf
      - file: /etc/collectd.d/tcpconns.conf
      - file: /etc/collectd.d/contextswitch.conf
      - file: /etc/collectd.d/irq.conf
      - file: /etc/collectd.d/interface.conf
