🧩 Aggregation of Multiple Repositories:

This repository (Fillit) serves as an aggregation point for several codebases originally developed and maintained in separate repositories. 
The mvp_aggregation branch consolidates these components into a unified structure for easier development, deployment, and collaboration.

🔧 Structure of the Aggregated Branch

Backend/

Contains the source code from the development branch of the Fillit_Backend repository. 
Here is the link to the actual Backend repository:

https://github.com/Benco351/Fillit_Backend

Frontend/

Contains the source code from the front_recent branch of the Fillit_Frontend repository.
Here is the link to the actual Frontend repository:

https://github.com/Benco351/Fillit_Frontend

Architecutre/
Contains the source code from the architrcture repository

Here is the link to the actual Architecutre repository:

https://github.com/Benco351/Fillit_Architecture

AI_lambda/

Contains the source code of AWS lambda that used as AI chat


📦 How the Aggregation Was Performed:

Worktrees were used to temporarily check out the relevant branches from the source repositories without cloning them fully.

The contents of those branches were copied into the corresponding folders (Backend/, Frontend/) in this repository.

All .git metadata from the source repositories was excluded to maintain a clean monorepo structure.

Changes were committed and pushed into the mvp_aggregation branch of this repository.

⚠️ Important Notes:

Note: The .git folders from the original repositories were removed during the migration to avoid embedding separate Git repositories within this one.

This method does not preserve Git history from the original repositories.
