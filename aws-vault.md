aws-vault exec PROFILE -- python3 /PATH/YOUR_SCRIPT.py

```python
import subprocess
import json
import boto3
def get_vault_session(aws_profile):
    aws_env_json = subprocess.check_output(['aws-vault', 'export', '--format=json', aws_profile])
    aws_env = json.loads(aws_env_json)
    return boto3.Session(
        aws_access_key_id=aws_env['AccessKeyId'],
        aws_secret_access_key=aws_env['SecretAccessKey'],
        aws_session_token=aws_env['SessionToken'],
    )
```
