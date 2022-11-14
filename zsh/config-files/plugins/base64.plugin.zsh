function base64e {
	# base64 <<< "$@" doesn't 100% work, it causes a trailing newline which is invalid in some cases
	echo -n "$@" | basenc --base64
}

function base64urle {
	echo -n "$@" | basenc --base64url
}

function base64d {
	echo -n "$@" | basenc --base64 -d
}

function base64urld {
	echo -n "$@" | base64 --base64url -d
}
