# originally from https://github.com/jtaisa/java-zsh-plugin

function java_versions {
	reply=($(ls /Library/Java/JavaVirtualMachines | sed 's/[^[:digit:]]//g'))
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
