
app_dir=$(config app_dir)
app_user=$(config app_user)
app_source_url=$(config app_source_url)
git_branch=$(config git_branch)

sudo useradd -m --shell `which bash` $app_user

sudo cpanm -q Ubic Ubic::Service::Plack || exit 1
sudo cpanm -q Starman || exit 1

sudo mkdir -p $app_dir
sudo chown $app_user $app_dir

sudo ubic-admin setup --batch-mode --quiet
sudo ubic stop perl-app

if test -d $app_dir/.git; then
  sudo -u $app_user bash --login -c "cd $app_dir && git pull && carton install --deployment"
else
  sudo -u $app_user bash --login -c "git clone --branch $git_branch $app_source_url $app_dir \
  && cd $app_dir && carton install --deployment" 
fi


sudo mkdir -p  /etc/ubic/service/

cat << EOF > /tmp/dancer_app.ubic.conf  

use parent qw(Ubic::Service::Plack);
 
# if your application is not installed in @INC path:
sub start {
    my \$self = shift;
    \$ENV{PERL5LIB} = "$app_dir/local/lib/perl5";
    \$self->SUPER::start(@_);
}
 
__PACKAGE__->new(
    server => 'Starman',
    app => "$app_dir/app.psgi",
    port => 5000,
    user => "$app_user",
);

EOF

sudo cp /tmp/dancer_app.ubic.conf /etc/ubic/service/perl-app

sudo ubic start perl-app

sudo ubic status perl-app && echo install-ok

