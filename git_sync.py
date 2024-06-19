import os
import subprocess
import time
import getpass
import sys


list_of_submodules = []

if __name__ == "__main__":
    subprocess.call(["git", "pull"])

    for submodule in list_of_submodules:
        os.chdir(submodule)
        print("PULLING submodule: " + submodule + "\n")
        subprocess.call(["git", "pull"])
        print("PUSHING submodule: " + submodule + "\n")
        subprocess.call(["git", "add", "."])
        subprocess.call(["git", "commit", "-m", "Update " + submodule])
        subprocess.call(["git", "push"])
        os.chdir("..")
        print("PUSHING app update: " + submodule + "\n")

    comment = "Update "
    for submodule in list_of_submodules:
        subprocess.call(["git", "add", submodule])
        comment += submodule + ", "
    comment = comment[:-2]

    subprocess.call(["git", "commit", "-m", comment.strip()])

    subprocess.call(["git", "add", "."])

    username = getpass.getuser()
    date_time = time.strftime("%Y-%m-%d %H:%M")

    # get current branch name
    branch_name = subprocess.check_output(["git", "rev-parse", "--abbrev-ref", "HEAD"]).strip().decode("utf-8")

    commit_message = f"By {username} <{branch_name}> at {date_time}"

    if len(sys.argv) > 1:
        commit_message += ": " + sys.argv[1]
        for argv in sys.argv[2:]:
            commit_message += " " + argv

    subprocess.call(["git", "commit", "-m", commit_message])

    subprocess.call(["git", "push"])

    print("DONE\n")
