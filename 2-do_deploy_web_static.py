#!/usr/bin/python3
from fabric.api import *
from os.path import exists

env.hosts = ['54.157.136.99', '54.173.109.63']
env.user = 'ubuntu'
env.key_filename = '~/path/to/your/private/key'


def do_deploy(archive_path):
    if not exists(archive_path):
        return False

    try:
        archive_name = archive_path.split('/')[-1]
        archive_name_without_ext = archive_name.split('.')[0]

        put(archive_path, '/tmp/')
        run('mkdir -p /data/web_static/releases/{}/'.format(archive_name_without_ext))
        run('tar -xzf /tmp/{} -C /data/web_static/releases/{}/'.format(archive_name, archive_name_without_ext))
        run('rm /tmp/{}'.format(archive_name))
        run('mv /data/web_static/releases/{}/web_static/* /data/web_static/releases/{}/'.format(archive_name_without_ext, archive_name_without_ext))
        run('rm -rf /data/web_static/releases/{}/web_static'.format(archive_name_without_ext))
        run('rm -rf /data/web_static/current')
        run('ln -s /data/web_static/releases/{}/ /data/web_static/current'.format(archive_name_without_ext))

        return True

    except Exception as e:
        return False


if __name__ == "__main__":
    archive_path = "versions/web_static_20170315003959.tgz"
    do_deploy(archive_path)
