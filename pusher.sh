if ! command -v gh >/dev/null 2>&1; then
    echo "Install gh first (https://cli.github.com/)."
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "Install git first (https://git-scm.com/)."
    exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
    echo "You need to login: gh auth login"
    exit 1
fi

Help()
{
   echo "Script to support git pushes and secrets storing in repo."
   echo
   echo "Syntax: pusher.sh [-p \"Commit Msg\"|h|]"
   echo "options:"
   echo "p     add files, commit and push to git repo."
   echo "h     Print this Help."
   echo
}


commit_and_push() 
{
	openssl base64 -A -in .env -out env.txt
	git add .
	git commit -m $commit_msg
	git push
	gh secret set MYSECRETS < env.txt
	rm env.txt

}



while getopts p:h flag
do
    case "${flag}" in
    	h) Help exit;;
        p) commit_msg=${OPTARG};;
    esac
done