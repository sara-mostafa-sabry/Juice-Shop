Create 3 VMs using terraform :
- 1 Master node, 1 worker node.
- 1 Jumber node.

```bash
terraform init
terraform validate 
terraform plan -out=task
terraform apply
```

- Install ansible on bastion
```bash
sudo apt update
sudo apt install ansible
ansible --version

sudo apt install -y apt-transport-https ca-certificates curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# REF: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
```

Cluster configuration:
- SSH to jumber VM: Using ip, cluster_rsa key.
- Copy key in same path ./ssh/cluster_key
- change permission 
```bash
chmod 600 ~/.ssh/cluster_rsa
```
- check connection to master node
```bash
ssh -i ~/.ssh/cluster_rsa ubuntu@10.0.2.241
```

- check connection to worker node
```bash
ssh -i ~/.ssh/cluster_rsa ubuntu@10.0.2.135
```

- install k8s
```bash
ansible-playbook -i hosts.ini main.yml
```

- Verify installation
```bash
ssh -i ~/.ssh/cluster_rsa ubuntu@10.0.2.241
kubectl get nodes -owide
```

- copy `.kube/config` to bastion
```bash
mkdir .kube
vi config  ## then copy content
kubectl get nodes -owide # verify
```

----------------------------------------------------------------------------------------------------------

Deploy Juice Shop Application
- create Juice-Shop.yaml
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: juice-shop

---  
apiVersion: apps/v1
kind: Deployment
metadata:
  name: juice-shop
  namespace: juice-shop  
  labels:
    app: juice-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: juice-shop
  template:
    metadata:
      labels:
        app: juice-shop
    spec:
      containers:
      - name: juice-shop
        image: bkimminich/juice-shop
        ports:
        - containerPort: 3000

---
apiVersion: v1
kind: Service
metadata:
  name: juice-shop
  namespace: juice-shop  
spec:
  type: ClusterIP
  selector:
    app: juice-shop
  ports:
    - port: 80
      targetPort: 3000

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: juice-shop-ingress
  namespace: juice-shop  
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: juice-shop.example.com  
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: juice-shop
            port:
              number: 80    
```

```bash
 kubectl apply -f Juice-Shop.yaml

vi /etc/hosts
10.0.2.241   juice-shop.example.com  
curl juice-shop.example.com 
```

