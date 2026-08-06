# Existing Project

> [!WARNING]  
> This page is being deprecated in favor of [Basic Setup](/addons/maaacks_input_remapping/docs/BasicSetup.md).


To revisit any part of the initial setup, find the `Setup Wizard` at `Project > Tools > Run Maaack's Input Remapping Setup...`. Example files can be re-copied from the `Setup Wizard`, assuming they have not been deleted.

1.  Add readable names for input actions to the controls menu.
    

    1.  Open `input_options_menu.tscn`.
    2.  In the scene tree, select the `Controls` node.  
    3.  In the node inspector, select the desired input remapping mode (defaults to `List`).  
    4.  In the scene tree, select `InputActionsList` or `InputActionsTree`, depending on the choice of input remapping. The other node should be hidden.  
    5.  In the node inspector, update the `Input Action Names` and corresponding `Readable Action Names` to show user-friendly names for the project's input actions.  
    6.  Save the scene.  


2.  Continue with:

    1.  [Adding icons to the Input Options.](/addons/maaacks_input_remapping/docs/InputIconMapping.md)  
