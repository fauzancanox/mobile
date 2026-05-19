# TODO for Adding Medicine Management CRUD Screen in Manajemen Obat Flutter App

- [ ] Create MedicineManagementScreen StatefulWidget:
  - Maintain in-memory list of medicines (id, name, description, quantity).
  - UI:
    - ListView to display medicines.
    - FloatingActionButton to add new medicines via dialog.
    - Edit and Delete buttons/items for each medicine entry.

- [ ] Add route entry '/medicine_management' => MedicineManagementScreen() in MaterialApp routes.

- [ ] Integrate navigation:
  - Add a new BottomNavigationBar item labeled "Medicine" in BerandaScreen.
  - Update bottom nav index handler to navigate to MedicineManagementScreen.

- [ ] Preserve existing navigation and program structure.

- [ ] Manual testing of CRUD operations in-memory.
