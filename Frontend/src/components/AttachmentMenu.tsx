import {Menu, MenuItem} from '@mui/material'


interface AttachmentProps {
    anchorEl: HTMLElement | null,
    onClose: () => void,
    onSelect: (type: "images" | "code") => void
}

export default function AttachmentMenu({anchorEl, onClose, onSelect}: AttachmentProps) {
    return (
        <Menu
        anchorEl={anchorEl}
        open={Boolean(anchorEl)}
        onClose={onClose}
        slotProps={{
        paper: {
            sx: {
                backgroundColor: '#252525', // Dark background
                color: '#FFFFFF',          // Light text
                borderRadius: '12px',       // Rounded corners
                border: '1px solid #3b3b3b', // Subtly lighter border
                padding: '8px',
                // Add custom styles for padding, box-shadow, etc.
                }
            }
        }}
>
        <MenuItem>Image</MenuItem>
        <MenuItem>Code</MenuItem>
        </Menu>
    )
}