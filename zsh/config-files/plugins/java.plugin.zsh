# set up only for mac, since this requires mac's java_home
if [[ $(uname -s) == Darwin* ]]; then
	# originally from https://github.com/jtaisa/java-zsh-plugin
	function java_versions {
		# zulu-11.jdk -> 11
		# zulu-8.jdk -> 1.8
		reply=($(ls --color=never /Library/Java/JavaVirtualMachines | sed 's/[^[:digit:]]//g' | sed 's/8/1.8/'))
	}

	function remove_from_path {
		export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
	}

	function jdk {
		if [ $# -ne 0 ]; then
			if [ -n "${JAVA_HOME+x}" ]; then
				remove_from_path $JAVA_HOME
			fi

			export JAVA_VERSION=$1
			export JAVA_HOME=`/usr/libexec/java_home -v $1`
			export PATH=$JAVA_HOME/bin:$PATH
		fi

		echo "JAVA_HOME: $JAVA_HOME"
		echo -n $(java -version)
	}

	compctl -K java_versions jdk
fi

if (( $+commands[mvn] )); then
	alias mvn="mvn -T 1C -Dmaven.test.skip -DskipTests -Dmaven.javadoc.skip=true"
fi
