# iocage-plugin-grocy

Artifact file(s) for [grocy](https://grocy.info)

### Install
```
wget -O /tmp/grocy.json https://raw.githubusercontent.com/dacto/iocage-plugin-grocy/master/grocy.json
iocage fetch dhcp=on vnet=on bpf=yes --plugin-name /tmp/grocy.json --branch 'master'
```


### Properties
Properties from `settings.json` can be managed through iocage:
```
iocage get -P <PROPERTY> grocy
iocage set -P <PROPERTY>=<VALUE> grocy
```
