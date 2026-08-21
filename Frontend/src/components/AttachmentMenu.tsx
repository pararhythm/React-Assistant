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
                backgroundColor: '#252525',
                color: '#FFFFFF',          
                borderRadius: '12px',       
                border: '1px solid #3b3b3b', 
                padding: '8px',
                }
            }
        }}
>
        <MenuItem>Image</MenuItem>
        <MenuItem>Code</MenuItem>
        </Menu>
    )
}