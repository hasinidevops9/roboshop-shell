log_file=/tmp/roboshop.log
rm -rf $log_file
nodejs_setup() {
echo -e \\e[36m configure nodejs repos \\e[0m
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &>>$log_file
echo $?

echo -e \\e[36m install nodejs \\e[0m
dnf install -y nodejs &>>$log_file
echo $?

echo -e \\e[36m Create app user \\e[0m
useradd -r -s /bin/false appuser &>>$log_file
echo $?

rm -rf /app
mkdir -p /app

echo -e \\e[36m Downloading ${app_name} code \\e[0m
curl -L -o /tmp/${app_name}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${app_name}.zip &>>$log_file
echo $?

cd /app

echo -e \\e[36m Extracting ${app_name} code \\e[0m
unzip /tmp/${app_name}.zip &>>$log_file
echo $?

echo -e \\e[36m Compile app code \\e[0m
npm install --production &>>$log_file
echo $?

echo -e \\e[36m Setup permissions to app code \\e[0m
chown -R appuser:appuser /app &>>$log_file
chmod o-rwx /app -R &>>$log_file
echo $?

echo -e \\e[36m Start service \\e[0m
systemctl daemon-reload &>>$log_file
systemctl enable ${app_name} &>>$log_file
systemctl restart ${app_name} &>>$log_file
echo $?

}