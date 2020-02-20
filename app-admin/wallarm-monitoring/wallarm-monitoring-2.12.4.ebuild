# Copyright 2019 RBK.MONEY
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DEB_ARCH="all"

DESCRIPTION="Wallarm - common files"
HOMEPAGE="http://wallarm.com"
SRC_URI="http://repo.wallarm.com/ubuntu/wallarm-node/bionic/pool/${PN}_${PV}_${DEB_ARCH}.deb"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="net-analyzer/monitoring-plugins
		app-metrics/collectd[collectd_plugins_threshold]
		dev-python/cryptography
		dev-python/pynsca
		dev-python/msgpack
		dev-python/pyyaml"
BDEPEND=""

PATCHES=(
		"${FILESDIR}/WallarmAPIWriter-2to3.patch"
)

src_unpack() {
		mkdir "${WORKDIR}/${P}" && cd "${WORKDIR}/${P}"
		unpack_deb ${A}
}

src_prepare() {
		default

		unpack usr/share/doc/${PN}/changelog.gz
		unpack usr/share/doc/${PN}/NEWS.Debian.gz
		sed -i 's/<P/LoadPlugin python\n\n<P/' etc/collectd/collectd.conf.d/write_api.conf
}

src_install() {
		dodoc usr/share/doc/${PN}/copyright
		dodoc changelog
		dodoc NEWS.Debian

		insinto "/usr/$(get_libdir)"
		doins -r usr/lib/nagios
		fperms -R 755 /usr/$(get_libdir)/nagios/plugins
		doins -r usr/lib/collectd

		insinto "/etc/collectd/conf.d"
		doins etc/collectd/collectd.conf.d/write_api.conf
		doins etc/collectd/collectd.conf.d/traps.conf
}
