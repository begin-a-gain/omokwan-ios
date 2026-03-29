remove:
	rm -rf **/**/*.xcodeproj
	rm -rf **/**/Derived
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/**/Derived
	rm -rf *.xcworkspace

clean:
	tuist clean
	make remove
	@if [ -e ./Package.resolved ] ; then \
		rm ./Package.resolved; \
	fi
	@if [ -e ./graph.png ] ; then \
		rm graph.png; \
	fi

generate:
	tuist install
	sh ./ci_scripts/post_clone/disable_tca_swift6_manifest.sh
	tuist generate

presentation:
	tuist scaffold Presentation --name $(name)

module:
	tuist scaffold Module --name $(name)

util:
	tuist scaffold Util --name $(name)
