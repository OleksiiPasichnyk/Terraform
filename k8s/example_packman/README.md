# Running Pacman in Minikube

Follow these steps to set up and run Pacman on a Minikube cluster:

1. **Start Minikube**

2. **Set Kubernetes Context**
Ensure you are in the proper Kubernetes cluster:

3. **Set Kubernetes Namespace**
Make sure you are using the proper namespace (pacman):

4. **Deploy MongoDB**
Apply the MongoDB deployment and check the pod logs:
Then retrieve and view the logs of the MongoDB pod:
a. Retrieve Pod ID:
   ```
   kubectl get pods
   ```
b. View Pod Logs:
   ```
   kubectl logs <pod_ID>
   ```

5. **Deploy Pacman**
Apply the Pacman deployment:

6. **Access Pacman Service**
Access the Pacman service deployed in Minikube:

7. **Enjoy!**
Your Pacman game should now be running and accessible.
