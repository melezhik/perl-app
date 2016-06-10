
app_dir=$(config app_dir)
app_user=$(config app_user)
app_source_url=$(config app_source_url)
git_branch=$(config git_branch)

useradd $app_user

cpanm Ubic || exit 1
cpanm Starman || exit 1

sudo -u $app_user mkdir -p $app_dir

if test -d $app_dir/.git; then
  sudo -u $app_user -E bash --login -c "cd $app_dir && git pull && carton install --deployment"
else
  sudo -u $app_user -E bash --login -c "git clone --branch $git_branch $app_source_url $app_dir \
  cd $app_dir && carton install --deployment" 
fi


mkdir -p  /etc/ubic/service/

cat > /etc/ubic/service/dancer_app

use parent qw(Ubic::Service::Plack);
 
# if your application is not installed in @INC path:
sub start {
    my $self = shift;
    $ENV{PERL5LIB} = "$app_dir/local/lib";
    $self->SUPER::start(@_);
}
 
__PACKAGE__->new(
    server => 'Starman',
    app => "$app_dir/app.psgi",
    port => 5000,
    user => "$app_user",
);


echo install-ok

