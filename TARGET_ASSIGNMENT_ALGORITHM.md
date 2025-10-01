# Target Assignment Algorithm Implementation

## Overview
The target assignment algorithm automatically assigns archers to targets in alphabetical order using a round-robin distribution strategy. This ensures fair and organized target allocation for archery matches.

## Algorithm Details

### Core Components

#### 1. **TargetAssignment Entity**
- `assignmentId`: Unique identifier for the assignment
- `matchId`: Reference to the parent match
- `targetNumber`: Physical target number (1, 2, 3, etc.)
- `archers`: List of assigned archers with positions
- `createdAt`: Assignment timestamp

#### 2. **AssignedArcher Entity**
- `userId`: Reference to the archer
- `name`: Archer's display name
- `shootingPosition`: Position on target (A, B, C, D)
- `shootingOrder`: Shooting sequence (1-4)

### Assignment Process

#### Step 1: Alphabetical Sorting
```dart
users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
```
- Archers are sorted alphabetically by name (case-insensitive)
- Ensures consistent and predictable assignment order

#### Step 2: Target Calculation
```dart
final requiredTargets = (sortedArchers.length / maxArchersPerTarget).ceil();
final targetsToUse = requiredTargets > match.maxTargets ? match.maxTargets : requiredTargets;
```
- Calculates minimum targets needed (4 archers per target maximum)
- Respects match's maximum target limit
- Ensures efficient target utilization

#### Step 3: Round-Robin Distribution
```dart
for (int archerIndex = 0; archerIndex < sortedArchers.length; archerIndex++) {
  final targetIndex = archerIndex % targetsToUse;
  final positionIndex = archerIndex ~/ targetsToUse;
}
```
- Distributes archers evenly across available targets
- Uses modulo operation for target selection
- Uses integer division for position determination

#### Step 4: Position Assignment
```dart
const shootingPositions = ['A', 'B', 'C', 'D'];
final assignedArcher = AssignedArcher(
  shootingPosition: shootingPositions[positionIndex],
  shootingOrder: positionIndex + 1,
);
```
- Assigns shooting positions (A, B, C, D)
- Sets shooting order (1, 2, 3, 4)
- Maintains consistent position mapping

## Example Assignment

### Input
- **Archers**: Alice, Bob, Charlie, Diana, Eve, Frank, Grace
- **Max Targets**: 8
- **Max Archers per Target**: 4

### Output
```
Target 1: Alice (A-1), Charlie (B-2), Eve (C-3), Grace (D-4)
Target 2: Bob (A-1), Diana (B-2), Frank (C-3)
```

### Assignment Logic
1. **Alphabetical Order**: Alice, Bob, Charlie, Diana, Eve, Frank, Grace
2. **Target Distribution**: 
   - Alice → Target 1 (0 % 2 = 0)
   - Bob → Target 2 (1 % 2 = 1) 
   - Charlie → Target 1 (2 % 2 = 0)
   - Diana → Target 2 (3 % 2 = 1)
   - Eve → Target 1 (4 % 2 = 0)
   - Frank → Target 2 (5 % 2 = 1)
   - Grace → Target 1 (6 % 2 = 0)

3. **Position Assignment**:
   - Alice: Position A (0 ÷ 2 = 0), Order 1
   - Bob: Position A (1 ÷ 2 = 0), Order 1
   - Charlie: Position B (2 ÷ 2 = 1), Order 2
   - Diana: Position B (3 ÷ 2 = 1), Order 2
   - Eve: Position C (4 ÷ 2 = 2), Order 3
   - Frank: Position C (5 ÷ 2 = 2), Order 3
   - Grace: Position D (6 ÷ 2 = 3), Order 4

## Features

### Validation
- Maximum 4 archers per target
- Unique shooting positions per target
- Unique shooting orders per target
- Target capacity validation

### Statistics
- Total archers assigned
- Targets utilized
- Full targets count
- Average archers per target

### UI Components
- Interactive target assignment viewer
- Archer selection interface
- Real-time assignment updates
- Algorithm explanation panel

## Usage

### Service Implementation
```dart
final assignments = TargetAssignmentService.assignTargets(
  match: match,
  archers: archers,
);
```

### Validation
```dart
final isValid = TargetAssignmentService.validateAssignments(assignments);
```

### Statistics
```dart
final stats = TargetAssignmentService.getAssignmentStats(assignments);
```

## Benefits

1. **Fair Distribution**: Even allocation across targets
2. **Alphabetical Order**: Predictable and organized
3. **Efficient Utilization**: Optimal target usage
4. **Scalable**: Works with any number of archers/targets
5. **Consistent**: Repeatable results with same input

## Integration

The target assignment algorithm is integrated into:
- Match management system
- Offline data storage (Hive)
- UI demonstration page
- Real-time assignment updates

This implementation provides a robust foundation for archery match target assignment with clear algorithms, comprehensive validation, and an intuitive user interface.