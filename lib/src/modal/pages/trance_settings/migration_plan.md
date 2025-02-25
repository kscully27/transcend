# Trance Settings Modal Migration Plan

## Current Status

We have created a new structure for the trance settings modal, but the original implementation in `root_sheet_page.dart` (1567 lines) is still being used. We need to migrate the functionality from the original file to our new structure.

## Migration Steps

1. **Identify Dependencies**: Identify all dependencies and imports needed for the new files.
2. **Extract Core Logic**: Extract the core logic from `root_sheet_page.dart` and distribute it to the appropriate files.
3. **Update References**: Update any references to the old implementation to use the new one.
4. **Test**: Test the new implementation to ensure it works correctly.
5. **Remove Old Code**: Once the new implementation is working, remove the old code from `root_sheet_page.dart`.

## Detailed Plan

### Step 1: Create a Wrapper Class

Create a wrapper class that uses our new implementation but maintains the same API as the old one to minimize disruption.

### Step 2: Migrate Each Page

Migrate each page from the old implementation to the new one:

- **Root Page**: Migrate the intention selection page.
- **Modality Select Page**: Migrate the modality selection page.
- **Settings Page**: Migrate the settings page.
- **Advanced Settings Modal**: Migrate the advanced settings modal.

### Step 3: Update Entry Points

Update all entry points to the trance settings modal to use our new implementation.

### Step 4: Deprecate Old Implementation

Mark the old implementation as deprecated and add a comment directing users to the new implementation.

### Step 5: Remove Old Implementation

Once we're confident that the new implementation is working correctly and all references have been updated, remove the old implementation.

## Implementation Timeline

1. **Day 1**: Create wrapper class and migrate root page.
2. **Day 2**: Migrate modality select page and settings page.
3. **Day 3**: Migrate advanced settings modal and update entry points.
4. **Day 4**: Test and fix any issues.
5. **Day 5**: Deprecate old implementation and update documentation.
6. **Day 6**: Remove old implementation.

## Migration Risks

- **Breaking Changes**: The new implementation might have breaking changes that affect existing code.
- **Missing Functionality**: We might miss some functionality from the old implementation.
- **Integration Issues**: The new implementation might not integrate well with the rest of the app.

## Mitigation Strategies

- **Thorough Testing**: Test the new implementation thoroughly to ensure it works correctly.
- **Gradual Migration**: Migrate one page at a time and test each one before moving on.
- **Fallback Plan**: Keep the old implementation as a fallback until we're confident that the new one is working correctly.

## Next Steps

1. Create a wrapper class that uses our new implementation.
2. Start migrating the root page. 